## Yet Another Checkout System (YACS) based of Ruby

# Class Diagram

The below Class Diagrams describes all the implemented classes and their relationships.

![YACS Class Diagram](https://github.com/developertogo/yacs-checkout/blob/master/docs/YACS-Checkout-System.vpd.png)

There are 2 ways to try out the code sample with Docker or without Docker.
**Note**: This code was tested with Ruby 2.4.5 and 2.6.5

# 1. Run code sample with Docker

Install [Docker](https://hub.docker.com/?overlay=onboarding) if you don't have it yet.
```
git clone git://github.com/developertogo/yacs-checkout.git
cd yacs-checkout
docker build -t developertogo/yacs-checkout .
docker run -it --rm developertogo/yacs-checkout
```

# 2. Run code sample without Docker

Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/), and `bundler` if you don't have it already, as follows: `gem install bundle`. 
```
git clone git://github.com/developertogo/yacs-checkout.git
cd yacs-checkout
bundle install
ruby yacs_register.rb
```

# Unit Tests

Simply run:
```
$ rspec
```

