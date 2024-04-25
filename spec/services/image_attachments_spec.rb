# frozen_string_literal: true

RSpec.describe ImageAttachments do
  let_it_be(:format_count) { described_class::Constants::FORMATS.size }
  let_it_be(:image_size_count) { described_class::Constants::IMAGE_SIZES.size }
  let_it_be(:site_logo_size_count) { described_class::Constants::SITE_LOGO_SIZES.size }
  let_it_be(:total_size_count) { image_size_count + site_logo_size_count }

  describe "[:formats]" do
    it "has the expected size" do
      expect(described_class[:formats].size).to eq format_count
    end
  end

  describe "[:sizes]" do
    it "has the expected size" do
      expect(described_class[:sizes].size).to eq total_size_count
    end
  end

  describe "size enumerators" do
    shared_examples_for "a size enumerator" do |prefix|
      let(:expected_size_count) { public_send(:"#{prefix}_size_count") }

      it "can return an enumerator" do |example|
        expect(call_enumerator).to be_a_kind_of(Enumerator)
      end

      it "enumerates the right number of times" do
        expect(call_enumerator.count).to eq expected_size_count
      end

      it "yields the expected amount of times" do |example|
        expect do |b|
          call_enumerator(&b)
        end.to yield_control.exactly(expected_size_count).times
      end
    end

    let(:method_name) do |example|
      example.metadata[:method]
    end

    def call_enumerator(*args, **kwargs, &)
      if args.any? || kwargs.any?
        described_class.public_send(method_name, *args, **kwargs, &)
      else
        described_class.public_send(method_name, &)
      end
    end

    describe ".each_format", method: :each_format do
      it_behaves_like "a size enumerator", :format do
        let(:expected_size_count) { format_count }
      end
    end

    describe ".each_image_size", method: :each_image_size do
      it_behaves_like "a size enumerator", :image
    end

    describe ".each_scoped_size", method: :each_scoped_size do
      it "allows :image" do
        expect do |b|
          call_enumerator(:image, &b)
        end.to yield_control.exactly(image_size_count).times
      end

      it "allows :site_logo" do
        expect do |b|
          call_enumerator(:site_logo, &b)
        end.to yield_control.exactly(site_logo_size_count).times
      end

      it "raises an error else-wise" do
        expect do
          call_enumerator(:anything)
        end.to raise_error RuntimeError, /unknown scope/i
      end
    end

    describe ".each_site_logo_size", method: :each_site_logo_size do
      it_behaves_like "a size enumerator", :site_logo
    end

    describe ".each_size", method: :each_size do
      it_behaves_like "a size enumerator", :total
    end
  end

  describe ".image_size" do
    it "works as expected", :aggregate_failures do
      expect(described_class.image_size(:hero)).to be_a_kind_of(ImageAttachments::Size)
      expect(described_class.image_size(:large)).to be_a_kind_of(ImageAttachments::Size)
      expect(described_class.image_size(:medium)).to be_a_kind_of(ImageAttachments::Size)
      expect(described_class.image_size(:small)).to be_a_kind_of(ImageAttachments::Size)
      expect(described_class.image_size(:thumb)).to be_a_kind_of(ImageAttachments::Size)
      expect do
        described_class.image_size :something
      end.to raise_error KeyError
    end
  end

  describe ".image_size?" do
    it "works as expected", :aggregate_failures do
      expect(described_class).to be_image_size(:hero)
      expect(described_class).not_to be_image_size(:not_found)
    end
  end

  describe ".site_logo_size" do
    it "works as expected", :aggregate_failures do
      expect(described_class.site_logo_size(:sans_text)).to be_a_kind_of(ImageAttachments::Size)
      expect(described_class.site_logo_size(:with_text)).to be_a_kind_of(ImageAttachments::Size)
      expect do
        described_class.site_logo_size :something
      end.to raise_error KeyError
    end
  end

  describe ".site_logo_size?" do
    it "works as expected", :aggregate_failures do
      expect(described_class).to be_site_logo_size(:sans_text)
      expect(described_class).not_to be_site_logo_size(:not_found)
    end
  end
end
