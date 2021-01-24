require 'dartt/config'

RSpec.describe Dartt::Config do
  it "can be created" do
    Dartt::Config.build
  end

  it "has a default width" do
    c = Dartt::Config.build
    expect(c[:width]).to be_an(Integer)
  end

  it "the default width can be overridden with an initializer hash" do
    c = Dartt::Config.build(
        {
            :width => 24
        }
    )
    expect(c[:width]).to eq(24)
  end
end