# frozen_string_literal: true

require "spec_helper"

describe Authenticatable do
  it { expect(Authenticatable::VERSION).to be_truthy }

  it "can be configured with #setup" do
    described_class.configure do |config|
      config.password_length = 8..16
    end

    expect(described_class.config.password_length).to eq(8..16)
    described_class.reset_default_values!
  end

  describe "configuration default values" do
    it { expect(described_class.config.default_extensions).to eq(%i[warden]) }
    it { expect(described_class.config.password_length).to eq(6..128) }
  end
end
