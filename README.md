
# Securing ColdFusion Scheduled Tasks In A Dockerized Container

by [Ben Nadel][bennadel]

This is an experiment to see various way in which we can secure a ColdFusion scheduled task. This way, we can be sure that the scheduled task is not being initiated via a public request from a potentially malicious actor. This demo uses a [Lucee CFML / nginx image][lucee-docker] from Lucee CFML's official docker images.

**CAUTION:** I am _neither_ a security expert nor a Docker expert!!

Security techniques:

* Lock down to an internal IP address (localhost).
* Lock down to an internal port (Tomcat).
* Lock down with an invocation password (ENV variable).


[bennadel]: https://www.bennadel.com/

[lucee-docker]: https://github.com/lucee/lucee-dockerfiles
