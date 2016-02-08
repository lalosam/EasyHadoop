.ONESHELL:
SHELL=/bin/bash
.SHELLFLAGS = -e
config-ssh:
	ssh -q -o "StrictHostKeyChecking no" -o "BatchMode yes" localhost exit && \
	  echo "SSH is current configured to connect with localhost" || \
    ( echo "Configuring localhost without passphrase on SSH"; \
		ssh-keygen -t dsa -P '' -f "$(HOME)/.ssh/id_dsa"; \
		cat $(HOME)/.ssh/id_dsa.pub >> $(HOME)/.ssh/authorized_keys )
