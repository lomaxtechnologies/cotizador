# Infrastructure Projects Quote - Lomax Technologies

A web application that provides an easy way to create simple and comparative quotations. Brands **Siemon** and **Supranet** are used for comparative quotations.

Instalation steps:

```bash
git pull origin master
rails assets:clean
rails assets:precompile RAIS_ENV=production
sudo service nginx restart
```
