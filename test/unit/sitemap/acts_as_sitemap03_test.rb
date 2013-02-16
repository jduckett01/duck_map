require 'test_helper'

class ActsAsSitemap03Test < ActiveSupport::TestCase

  ##################################################################################
  test "acts_as_sitemap title: nil" do

    DuckMap::Config.reset

    DuckMap::Config.acts_as_sitemap title: nil

    assert HashModel.verify("unit/sitemap/models/test03", DuckMap::Config.sitemap_attributes_hash)

  end

  ##################################################################################
  test "multi acts_as_sitemap title: nil" do

    DuckMap::Config.reset

    # prove you can use the same statement over and over again
    DuckMap::Config.acts_as_sitemap title: nil
    DuckMap::Config.acts_as_sitemap title: nil
    DuckMap::Config.acts_as_sitemap title: nil

    assert HashModel.verify("unit/sitemap/models/test03", DuckMap::Config.sitemap_attributes_hash)

  end

  ##################################################################################
  test "config block acts_as_sitemap title: " do

    DuckMap::Config.reset

    Rails.application.routes.draw do
      acts_as_sitemap title: nil
    end

    assert HashModel.verify("unit/sitemap/models/test03", DuckMap::Config.sitemap_attributes_hash)

  end

  ##################################################################################
  test "class acts_as_sitemap title: " do

    # reset here in case other tests bigfoot the class variables.
    DuckMap::Config.reset

    class ActsAsSitemap03TestObject01
      include DuckMap::InheritableClassAttributes
      include DuckMap::Attributes
      include DuckMap::SitemapObject

      acts_as_sitemap title: nil

    end

    a = ActsAsSitemap03TestObject01.new

    assert HashModel.verify("unit/sitemap/models/test03", a.sitemap_attributes_hash)

  end

  ##################################################################################
  test "object acts_as_sitemap title: " do

    # reset here in case other tests bigfoot the class variables.
    DuckMap::Config.reset

    class ActsAsSitemap01TestObject02
      include DuckMap::InheritableClassAttributes
      include DuckMap::Attributes
      include DuckMap::SitemapObject

      acts_as_sitemap title: nil

    end

    assert HashModel.verify("unit/sitemap/models/test03", ActsAsSitemap01TestObject02.sitemap_attributes_hash)

  end

end










