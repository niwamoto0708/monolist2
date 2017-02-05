class RankingsController < ApplicationController
    before_action :logged_in_user
    
    def have_ranking
        @items = Have.top10
    end
    
    def want_ranking
        @items = Want.top10
    end
end