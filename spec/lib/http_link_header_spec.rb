require 'spec_helper'

RSpec.describe HttpLinkHeader do
  let(:url) { 'http://example.com/?page=1' }
  let(:rel_types) { 'next' }
  let(:link) { "<#{url}>; rel=\"#{rel_types}\"" }

  describe 'add' do
    it 'should add the link' do
      expect {
        subject.add(link)
      }.to change {subject.length}.by(1)
    end

    it 'should add the url to []' do
      expect {
        subject.add(link)
      }.to change {subject[url]}.from(nil)
    end

    it 'the added url should point to an HttpLinkParam object' do
      subject.add(link)

      expect(subject[url]).to be_a(HttpLinkHeader::HttpLinkParams)
    end

    it 'the link params should have the rel relation' do
      subject.add(link)

      expect(subject[url][:rel]).to be_a(HttpLinkHeader::HttpLinkParams::RelationTypes)
    end
  end

  describe '#rel' do
    it 'should find the url by rel type' do
      subject.add(link)

      expect(subject.rel('next')).to eq(url)
    end

    context 'with multiple rel types' do
      let(:rel_types) { 'next last' }

      it 'should find the url by the next type' do
        subject.add(link)

        expect(subject.rel('next')).to eq(url)
      end

      it 'should find the url by the last type' do
        subject.add(link)

        expect(subject.rel('last')).to eq(url)
      end
    end
  end
end