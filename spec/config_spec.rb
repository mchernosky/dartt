require 'dartt/config'

RSpec.describe Dartt::Config do
  it "can be created" do
    Dartt::Config.build
  end

  it "has a default width" do
    c = Dartt::Config.build
    expect(c[:width]).to be_an(Integer)
  end

  it "can override the default width with an initializer hash" do
    c = Dartt::Config.build(
        {
            :width => 24
        }
    )
    expect(c[:width]).to eq(24)
  end

  it "can override the title height with an initializer hash" do
    c = Dartt::Config.build(
        {
            :title => {
                :height => 500
            }
        }
    )
    expect(c[:title][:height]).to eq(500)
  end

  it "can override the title font color with an initializer hash" do
    c = Dartt::Config.build(
        {
            :title => {
                :font_color => "pink"
            }
        }
    )
    expect(c[:title][:font_color]).to eq("pink")
  end

  it "preserves the default configuration when adding a custom configuration" do
    c = Dartt::Config.build(
        {
            :title => {
                :font_color => "pink"
            }
        }
    )
    expect(c[:title]).to include(:height)
  end
end