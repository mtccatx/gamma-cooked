# *Γ-cooked*: An experimental language and a "game"

Γ-cooked is a project for [Langjam 2025](https://langjamgamejam.com/).
It is an experiment in system game building use a rule language based on the Γ-model[^1] combined with spatial queries.

[^1]:  [A parallel machine for multiset transformation and its programming style](https://doi.org/10.1016/0167-739X(88)90012-X). J.-P. Banâtre, A. Coutant, D. Le Metayer.


## Usage

### Game

`game` is a Godot project and should be openable as usual.

### Compiler

`compiler` is a Scala/SBT project with configuration files for IntelliJ IDEA.
You can launch the compiler with `sbt run` in the `compiler` directory if you have [SBT installed](https://www.scala-sbt.org/download).
