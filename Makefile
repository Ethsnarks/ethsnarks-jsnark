JSNARK_SRC=jsnark/JsnarkCircuitBuilder/src
PINOCCHIO=ethsnarks/bin/pinocchio
JSNARK_TEST=ethsnarks/bin/jsnark_test
JSNARK=java -cp jsnark.jar

JSNARK_CIRCUITS=sha_256 AES_Circuit dot_product enc_example rsa2048_encryption rsa2048_sha256_sig_verify # tree_64

all: jsnark.jar $(addsuffix .proof.json, $(JSNARK_CIRCUITS))

%.raw: %.arith
	time $(PINOCCHIO) $< eval $(basename $<).in
	time $(PINOCCHIO) $< genkeys $@ $(basename $<).vk.json

%.proof.json: %.raw
	time $(PINOCCHIO) $(basename $<).arith prove $(basename $<).in $(basename $<).raw $(basename $<).proof.json
	time $(PINOCCHIO) $(basename $<).arith verify $(basename $<).vk.json $(basename $<).proof.json

jsnark/LICENSE:
	# Update submodules
	git submodule update --init --recursive

sha_256.arith: jsnark.jar
	$(JSNARK) examples.generators.hash.SHA2CircuitGenerator

AES_Circuit.arith: jsnark.jar
	$(JSNARK) examples.generators.blockciphers.AES128CipherCircuitGenerator

rsa2048_sha256_sig_verify.arith: jsnark.jar
	$(JSNARK) examples.generators.rsa.RSASigVerCircuitGenerator

rsa2048_encryption.arith: jsnark.jar
	$(JSNARK) examples.generators.rsa.RSAEncryptionCircuitGenerator

tree_64.arith: jsnark.jar
	$(JSNARK) examples.generators.hash.MerkleTreeMembershipCircuitGenerator

dot_product.arith: jsnark.jar
	$(JSNARK) examples.generators.math.DotProductCircuitGenerator

enc_example.arith: jsnark.jar
	$(JSNARK) examples.generators.hybridEncryption.HybridEncryptionCircuitGenerator

jsnark.jar: $(JSNARK_SRC)/util/Util.class
	# Combine into .jar file
	jar cvf $@ -C $(JSNARK_SRC) .

$(JSNARK_SRC)/util/Util.class: jsnark/LICENSE
	# Build all class files
	cd $(JSNARK_SRC) && javac -cp /usr/share/java/bcprov.jar:/usr/share/java/junit.jar:. circuit/*/*.java circuit/*/*/*.java util/*.java examples/*/*.java examples/*/*/*.java

clean:
	find $(JSNARK_SRC) -name '*.class' -exec rm -f '{}' ';'
	rm -f jsnark.jar
