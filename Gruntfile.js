'use strict';

module.exports = function(grunt) {
    grunt.initConfig({
        coffee: {
            compileBare: {
                options: {
                    bare: true
                },
                files: {
                    'crx/main.js': [
                        'src/env.coffee',
                        'src/main.coffee'
                    ]
                }
            },
            compileBareMaps: {
                options: {
                    sourceMap: true,
                    bare: true
                },
                files: {
                    'crx/main.js': [
                        'src/envd.coffee',
                        'src/main.coffee'
                    ]
                }
            }
        },
        uglify: {
            product: {
                files: {
                    'crx/main.js': ['crx/main.js']
                }
            }
        },
        watch: {
            options: {
                dateFormat: function(time) {
                    grunt.log.writeln('The watch finished in ' + time + 'ms at' + (new Date()).toString());
                    grunt.log.writeln('Waiting for more changes...');
                }
            },
            script:{
                files: 'src/*.coffee',
                tasks:['coffee:compileBareMaps'],
                options:{
                    spawn:true
                }
            }
        }
    });

    // $ grunt uglify
    grunt.loadNpmTasks('grunt-contrib-uglify');

    // $ grunt coffee
    grunt.loadNpmTasks('grunt-contrib-coffee');

    // $ grunt watch
    grunt.loadNpmTasks('grunt-contrib-watch');

    // $ grunt
    grunt.registerTask('default', ['coffee:compileBare', 'uglify:product']);
};