const { merge } = require('webpack-merge');
const path = require('path');
const common = require('./webpack.common.js');

module.exports = merge(common, {
    devServer: {
        proxy: {
            "/api": {
                target: "http://localhost:8080", // our Spring Boot port
                changeOrigin: true,
                secure: false,
                pathRewrite: { "^/api": "" }
            }
        }
    }
});
