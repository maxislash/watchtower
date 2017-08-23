First, launch the install-app-env script (wait for the "All done" text):
./install-app-env.sh

After, launch the install-env script with the arguments ami-8ef056ee keyName securityGroupId nameOfTheLaunchConfiguration Count iamProfile (wait for the "All done" text:
example: ./install-env.sh ami-8ef056ee macmax4 sg-1a39c263 webserver 1 mdescos

To destroy everything:
./destroy-env.sh
