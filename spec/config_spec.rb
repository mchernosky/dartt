require 'dartt/config'

RSpec.describe Dartt::Config do
  it "can be created" do
    Dartt::Config.new
  end

  it "has a default font size" do
    c = Dartt::Config.new
    expect(c.font.size).to be_an(Integer)
  end

  it "can set a default size with an initializer hash" do
    c = Dartt::Config.new
    c.font.size = 24
    expect(c.font.size).to eq(24)
  end
end