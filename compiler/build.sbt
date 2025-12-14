ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "3.7.4"

lazy val root = (project in file("."))
  .settings(
    name := "compiler"
  )

libraryDependencies += "io.github.edadma" %% "indentation" % "0.0.1"
libraryDependencies += "org.scala-lang.modules" %% "scala-parser-combinators" % "2.4.0"
