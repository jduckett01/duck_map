require 'test_helper'

class NamespacesTest < ActiveSupport::TestCase

  ##################################################################################
  test "full test" do

    Dummy::Application.routes.routes.clear
    Rails.application.routes.sitemap_filters.reset

    Dummy::Application.routes.draw do

      sitemap

      namespace :products do

        sitemap do                            # /products/sitemap.xml

          namespace :video do

            sitemap do                        # /products/video/sitemap.xml

              sitemap :bluray do              # /products/video/bluray.xml
                resources :blu_ray_players
              end
              
              resources :dvd_players
              resources :accessories
            end
          end

          namespace :audio do
            sitemap do                        # /products/audio/sitemap.xml
              resources :head_phones
              resources :speakers
              resources :accessories
            end
          end
          resources :papers
          resources :pencils
        end

      end

    root :to => 'home#index'                # included in the default sitemap: /sitemap.xml
    resources :faqs

    end

    sitemaps = {
                "/sitemap.xml" => ["root", "faqs", "faq"],
                "/products/sitemap.xml" => ["products_papers", "products_paper", "products_pencils", "products_pencil"],
                "/products/video/sitemap.xml" => ["products_video_dvd_players",
                                                  "products_video_dvd_player",
                                                  "products_video_accessories",
                                                  "products_video_accessory"],
                "/products/audio/sitemap.xml" => ["products_audio_head_phones",
                                                  "products_audio_head_phone",
                                                  "products_audio_speakers",
                                                  "products_audio_speaker",
                                                  "products_audio_accessories",
                                                  "products_audio_accessory"],
                "/products/video/bluray.xml" => ["products_video_blu_ray_players",
                                                  "products_video_blu_ray_player"]
                }

    sitemaps.each do |sitemap|

      sitemap_route = Rails.application.routes.find_sitemap_route(sitemap.first)
      assert sitemap_route.kind_of?(ActionDispatch::Journey::Route)

      sitemap_routes = Rails.application.routes.sitemap_routes(sitemap_route)

      assert sitemap_routes.length == sitemap.last.length

      sitemap.last.each do |route_name|
        assert sitemap_routes.find {|route| route.route_name.eql?(route_name)}.kind_of?(ActionDispatch::Journey::Route), "could not find route: #{route_name}"
      end

    end

  end

  ##################################################################################
  test "namespaced route with a block" do

    Dummy::Application.routes.routes.clear
    Rails.application.routes.sitemap_filters.reset

    Dummy::Application.routes.draw do

      sitemap

      namespace :products do

        sitemap do

        end

      end

    end

    assert Rails.application.routes.find_sitemap_route("/sitemap.xml").kind_of?(ActionDispatch::Journey::Route)
    assert Rails.application.routes.find_sitemap_route("/products/sitemap.xml").kind_of?(ActionDispatch::Journey::Route)

  end

  ##################################################################################
  test "named namespaced route without a block" do

    Dummy::Application.routes.routes.clear
    Rails.application.routes.sitemap_filters.reset

    Dummy::Application.routes.draw do

      sitemap

      namespace :products do

        sitemap :my_sitemap

      end

    end

    assert Rails.application.routes.find_sitemap_route("/sitemap.xml").kind_of?(ActionDispatch::Journey::Route)
    assert !Rails.application.routes.find_sitemap_route("/products/sitemap.xml").kind_of?(ActionDispatch::Journey::Route)
    assert Rails.application.routes.find_sitemap_route("/products/my_sitemap.xml").kind_of?(ActionDispatch::Journey::Route)

  end

  ##################################################################################
  test "named namespaced route with a block" do

    Dummy::Application.routes.routes.clear
    Rails.application.routes.sitemap_filters.reset

    Dummy::Application.routes.draw do

      sitemap

      namespace :products do

        sitemap :my_sitemap do

        end

      end

    end

    assert Rails.application.routes.find_sitemap_route("/sitemap.xml").kind_of?(ActionDispatch::Journey::Route)
    assert !Rails.application.routes.find_sitemap_route("/products/sitemap.xml").kind_of?(ActionDispatch::Journey::Route)
    assert Rails.application.routes.find_sitemap_route("/products/my_sitemap.xml").kind_of?(ActionDispatch::Journey::Route)

  end

end
























