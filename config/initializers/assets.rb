# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w(
                                                  landing_page.css
                                                  fontello.scss
                                                  fonts/fontello.eot
                                                  fonts/fontello.svg
                                                  fonts/fontello.ttf
                                                  fonts/fontello.woff
                                                  fancybox/jquery.fancybox.css
                                                  media-queries.css
                                                  buttons.css
                                                  styles.css
                                                  slider.css
                                                  footer.css

                                                  landing_page.js
                                                  navbar.js
                                                  slider.js
                                                  fancybox/jquery.fancybox.js
                                                  bootstrap-slider.js
                                                  theme-script.js
                                                  jquery_cycle2_center.min.js
                                                  jquery_cycle2.js

                                                  form_page.css
                                                  metronic/css/components.min.css
                                                  metronic/css/plugins/min.css
                                                  metronic/css/layout.min.css
                                                  metronic/css/themes/blue.min.css
                                                  bootstrap-fileinput/bootstrap-fileinput.css

                                                  form_page.js
                                                  metronic/js/plugins/jquery-validation/js/jquery.validate.min.js
                                                  metronic/js/plugins/jquery-validation/js/additional-methods.min.js
                                                  metronic/js/plugins/bootstrap-wizard/jquery.bootstrap.wizard.min.js
                                                  metronic/js/app.min.js
                                                  metronic/js/scripts/form-wizard.js
                                                  metronic/js/layout.min.js
                                                  rich/editor.css
                                                  bootstrap-fileinput/bootstrap-fileinput.js
                                                  jquery-repeater/jquery.repeater.min.js
                                                  form-repeater.js
                                                )
