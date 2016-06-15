class AddAdditionalTimeInfoToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :timezone, :string

    Feed.find_each do |feed|
      feed.update_attribute(:timezone, timezone(feed.slug))
    end
  end

  def timezone(slug)
    case
    when slug =~ 'radar'
      'Alaska'
    else
      'UTC'
    end
  end
end
