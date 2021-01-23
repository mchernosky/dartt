require 'dartt/config'

RSpec.describe Dartt::Config do
  it "can be created" do
    Dartt::Config.build
  end

  it "has a default width" do
    c = Dartt::Config.build
    expect(c[:width]).to be_an(Integer)
  end

  # it "can set a default size with an initializer hash" do
  #   c = Dartt::Config.new
  #   c.font.size = 24
  #   expect(c.font.size).to eq(24)
  # end
end