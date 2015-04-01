# npm-install-cache

Install `node_modules` from cache on unix-like systems.

	npm install -g npm-install-cache

## Usage

Navigate to node project and run

	npm-install-cache

If any changes to the `package.json` have been made since the last run the script executes `npm install` and stores a copy of the `node_modules` directory, these are used next time the script is executed.
