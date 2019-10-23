var webpack = require('webpack');
var VueLoaderPlugin = require("vue-loader/lib/plugin")

module.exports = env => {

  // environment mode
  var production = (env && env=="production") ? true : false
  //production = true

  return {
   watch: !production,
   watchOptions: {
      aggregateTimeout: 300,
      poll: 1000,
      ignored: /node_modules/
   },
   mode: (production == true) ? "production" : "development",
   optimization: { minimize: production },
   performance: { hints: false },
   entry: {
      "quotations": "./viewsrc/modules/quotations/quotations.js",
      "dashboards": "./viewsrc/modules/dashboards/dashboards.js",
   },
   output: {
      path: __dirname,
      filename: "app/assets/javascript/[name]/[name].js"
   },
   resolve: {
      alias: {
         vue: production ? "vue/dist/vue.min.js" : "vue/dist/vue.js"
      },
      extensions: [".js"]
   },
   module: {
      rules: [
         {
            test: /\.vue$/,
            loader: 'vue-loader'
         }, {
            test: /\.css$/,
            use: [
               'style-loader',
               'css-loader'
            ]
         },{
           test: /\.scss$/,
           use: [
              'style-loader', // creates style nodes from JS strings
              'css-loader',   // translates CSS into CommonJS
              {
                 loader: 'sass-loader', // compiles Sass to CSS, using Node Sass by default
              }
              
           ]
        }
      ]
   },
   plugins: [
      new VueLoaderPlugin()
   ]
  }
};
