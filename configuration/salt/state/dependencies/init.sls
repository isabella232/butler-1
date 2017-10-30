# Install dependencies on all the nodes

install_dependencies:
  pkg.installed:
    - name: java
    - name: python2-pip
