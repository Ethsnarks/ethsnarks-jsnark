JSNARK_SRC=jsnark/JsnarkCircuitBuilder/src
PINOCCHIO=ethsnarks/bin/pinocchio

all: jsnark.jar sha_256.raw

%.raw: %.arith %.in
	$(PINOCCHIO) $< eval $(basename $<).in
	$(PINOCCHIO) $< genkeys $@ $(basename $<).vk.json
	$(PINOCCHIO) $< prove $(basename $<).in $@ $(basename $<).proof.json
	$(PINOCCHIO) $< verify $(basename $<).vk.json $(basename $<).proof.json

jsnark/LICENSE:
	# Update submodules
	git submodule update --init --recursive

sha_256.in: jsnark.jar
	java -cp jsnark.jar examples.generators.hash.SHA2CircuitGenerator

jsnark.jar: $(JSNARK_SRC)/util/Util.class
	# Combine into .jar file
	jar cvf $@ -C $(JSNARK_SRC) .

$(JSNARK_SRC)/util/Util.class: jsnark/LICENSE
	# Build all class files
	cd $(JSNARK_SRC) && javac -cp /usr/share/java/bcprov.jar:/usr/share/java/junit.jar:. circuit/*/*.java circuit/*/*/*.java util/*.java examples/*/*.java examples/*/*/*.java

clean:
	find $(JSNARK_SRC) -name '*.class' -exec rm -f '{}' ';'
	rm -f jsnark.jar
