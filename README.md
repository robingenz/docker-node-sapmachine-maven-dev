# docker-node-sapmachine-maven-dev

🐳 Docker image for use as [VSCode Code Remote - Container](https://code.visualstudio.com/docs/remote/containers) with [NodeJS](https://nodejs.org/), [SapMachine](https://sap.github.io/SapMachine/) and [Maven](https://maven.apache.org/). 

## How to use this image

<!-- ### Pull image

Pull from Docker Registry:  
`docker pull robingenz/node-sapmachine-maven-dev` -->

### Build image

Build from GitHub:  
```
docker build -t robingenz/node-sapmachine-maven-dev github.com/robingenz/docker-node-sapmachine-maven-dev
```

Available build arguments:  

- NODEJS_VERSION
- SAP_MACHINE_VERSION
- MAVEN_VERSION

### Run image

Run the docker image:  
```
docker run -it robingenz/node-sapmachine-maven-dev bash
```

### Use with VSCode Code Remote

`devcontainer.json`:  

```json
// For format details, see https://aka.ms/vscode-remote/devcontainer.json or this file's README at:
// https://github.com/microsoft/vscode-dev-containers/tree/v0.112.0/containers/docker-existing-dockerfile
{
    "name": "docker-node-sapmachine-maven-dev",
    "context": "..",
    "image": "robingenz/node-sapmachine-maven-dev",
    "settings": {
        "terminal.integrated.shell.linux": "/bin/bash",
        "terminal.integrated.shellArgs.linux": [
            "-l"
        ]
    },
    "extensions": [],
}
```

## Questions / Issues

If you got any questions or problems using the image, please visit my [GitHub Repository](https://github.com/robingenz/docker-node-sapmachine-maven-dev) and write an issue.
