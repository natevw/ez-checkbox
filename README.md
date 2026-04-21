# Easy-check Box

Easy way to spin up a "box" to check client behavior.

## How it works

Provides a recursive DNS resolver which will redirect certain domains
to a TLS proxy running on itself.

The client will need to trust this proxy's root cert,
whether by custom pre-configuration or by its own insecure logic.

