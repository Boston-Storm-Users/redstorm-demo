# Redstorm Demo

Redstorm topology to parse data from the Twitter streaming API and display them via a node/socket.io application

## Getting Started

Below you'll find the step by step instructions install, setup, and run both the Redstorm versus topology and the Node versus-web application

### Versus Topology

1. Install JRuby (via rvm.io)
    
    ```
    $ rvm install jruby
    ```

2. Use JRuby and Create a gemset (via rvm.io)

    ```
    $ rvm use jruby@redstorm-demo --create
    ```

3. Bundle Install Ruby Gems

    ```
    $ bundle install
    ```

4. Install Redstorm

    ```
    $ redstorm install
    ```

5. Redstorm Bundle Topology

    ```
    $ redstorm bundle versus
    ```

6. Copy settings.yml.example to settings.yml

    ```
    $ cp settings.yml.example settings.yml
    ```

7. Add your Twitter OAuth credentials to settings.yml

    If needed visit [dev.twitter.com](https://dev.twitter.com/) to generate credentials
    
8. Run the versus topology locally

    ```
    redstorm local versus/versus_topology.rb
    ```    

### Versus Web App

1. Install Node (via mxcl.github.com/homebrew)

    ```
    brew install node
    ```

2. Change Directory

    ```
    $ cd versus-web
    ```

3. Install node packages

    ```
    $ npm install
    ```

4. Start the web application

    ```
    node app.js
    ```

5. Fire up your browser (localhost:3000)

    [versus-web](http://localhost:3000)

## Author

[Kyle Bolton](https://github.com/kb) | [@bolton](http://twitter.com/bolton) | [boltanium.com](http://boltanium.com)

## Contributors

* [Patrick Camacho](https://github.com/camacho)

## License

MIT License, See the [LICENSE](LICENSE.md) file.
