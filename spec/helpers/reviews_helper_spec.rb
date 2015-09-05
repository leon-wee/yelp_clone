require 'rails_helper'

describe ReviewsHelper, :type => :helper do
  context '#star_rating' do
    it 'does nothing for not a number' do
      expect(helper.star_rating('N/A')).to eq 'N/A'
    end

    it 'returns five black stars for five' do
      expect(helper.star_rating(5)).to eq '★★★★★'
    end

    it 'returns three black stars and two white stars for three' do
      expect(helper.star_rating(3)).to eq '★★★☆☆'
    end

    it 'returns four black stars and one white star for 3.5' do
      expect(helper.star_rating(3.5)).to eq '★★★★☆'
    end

  end

  context '#time_created' do
    it 'displays 0 hours ago when it is just created' do
      expect(helper.time_created(Time.now)).to eq 'Created 0 hours ago'
    end

    it 'displays 2 hours ago' do
      expect(helper.time_created(Time.now - 7200)).to eq 'Created 2 hours ago'
    end

    it 'displays 1 hour ago' do
      expect(helper.time_created(Time.now - 3600)).to eq 'Created 1 hour ago'
    end
  end
end
