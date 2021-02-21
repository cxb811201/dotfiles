addCompilerPlugin("org.scalameta" % "semanticdb-scalac" % "4.4.9" cross CrossVersion.full)
Global / scalacOptions += "-Yrangepos"
Global / bloopExportJarClassifiers := Some(Set("sources"))
