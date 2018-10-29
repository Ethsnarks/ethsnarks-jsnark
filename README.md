# jsnark and xjsnark for ethsnarks

This repository provides an example of integrating [jsnark](https://github.com/akosba/jsnark) circuits with [EthSnarks](http://github.com/HarryR/ethsnarks). It allows you to construct circuits using jsnark and [xjsnark](https://github.com/akosba/xjsnark) which can be proven on Ethereum.


## How it Works

jsnark and xjsnark output two files:

  * Circuit instructions (ending in `.arith`)
  * Input values (ending in `.in`)

EthSnarks ships with an executable called `pinocchio`, this takes the `.arith` and `.in` files to generate the proving and verification keys for the circuit, and then to create a proof.

### Evaluate the circuit and its inputs

	pinocchio mycircuit.arith eval mycircuit.in

### Generate proving key

Generates proving key file named `mycircuit.pk` and verification key named `mycircuit.vk.json`

	pinocchio mycircuit.arith genkeys mycircuit.pk mycircuit.vk.json

### Create proof

Uses the proving key `mycircuit.pk` to create a proof named `mycircuit.proof.json` for the inputs `mycircuit.in`

	pinocchio mycircuit.arith prove mycircuit.in mycircuit.pk mycircuit.proof.json

### Verify proof

Uses the verification key `mycircuit.vk.json` and the proof `mycircuit.proof.json`

	pinocchio mycircuit.arith verify mycircuit.vk.json mycircuit.proof.json


## Notes

The jsnark tool could be improved in the following ways:

 1. It's not necessary to output the values for every variable if the operations are evaluated
 2. Public inputs must be specified first in the circuit `.arith` file

The `pinocchio` tool could be improved in the following ways:

 1. If all variable values are provided by jsnark, there's no need to evaluate the circuit
