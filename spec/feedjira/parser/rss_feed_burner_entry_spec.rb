require "spec_helper"

describe Feedjira::Parser::RSSFeedBurnerEntry do
  before(:each) do
    tag = "wfw:commentRss"
    Feedjira::Feed.add_common_feed_entry_element(tag, as: :comment_rss)
    # I don't really like doing it this way because these unit test should only
    # rely on RSSEntry, but this is actually how it should work. You would
    # never just pass entry xml straight to the AtomEnry
    feed = Feedjira::Parser::RSSFeedBurner.parse sample_rss_feed_burner_feed
    @entry = feed.entries.first
  end

  after(:each) do
    # We change the title in one or more specs to test []=
    if @entry.title != "Angie’s List Sets Price Range IPO At $11 To $13 Per Share; Valued At Over $600M" # rubocop:disable Metrics/LineLength
      feed = Feedjira::Parser::RSS.parse sample_rss_feed_burner_feed
      @entry.title = feed.entries.first.title
    end
  end

  it "should parse the title" do
    title = "Angie’s List Sets Price Range IPO At $11 To $13 Per Share; Valued At Over $600M" # rubocop:disable Metrics/LineLength
    expect(@entry.title).to eq title
  end

  it "should parse the original url" do
    expect(@entry.url).to eq "http://techcrunch.com/2011/11/02/angies-list-prices-ipo-at-11-to-13-per-share-valued-at-over-600m/" # rubocop:disable Metrics/LineLength
  end

  it "should parse the author" do
    expect(@entry.author).to eq "Leena Rao"
  end

  it "should parse the content" do
    expect(@entry.content).to eq sample_rss_feed_burner_entry_content
  end

  it "should provide a summary" do
    expect(@entry.summary).to eq sample_rss_feed_burner_entry_description
  end

  it "should parse the published date" do
    published = Time.parse_safely "Wed Nov 02 17:25:27 UTC 2011"
    expect(@entry.published).to eq published
  end

  it "should parse the categories" do
    expect(@entry.categories).to eq ["TC", "angie\\'s list"]
  end

  it "should parse the guid as id" do
    expect(@entry.id).to eq "http://techcrunch.com/?p=446154"
  end

  it "should support each" do
    expect(@entry).to respond_to :each
  end

  it "should be able to list out all fields with each" do
    all_fields = []
    title_value = ""

    @entry.each do |field, value|
      all_fields << field
      title_value = value if field == "title"
    end

    title = "Angie’s List Sets Price Range IPO At $11 To $13 Per Share; Valued At Over $600M" # rubocop:disable Metrics/LineLength
    expect(title_value).to eq title

    expected_fields = %w(
      author
      categories
      comment_rss
      content
      entry_id
      published
      summary
      title
      url
    )
    expect(all_fields.sort).to eq expected_fields
  end

  it "should support checking if a field exists in the entry" do
    expect(@entry).to include "author"
    expect(@entry).to include "title"
  end

  it "should allow access to fields with hash syntax" do
    expect(@entry["author"]).to eq "Leena Rao"
    title = "Angie’s List Sets Price Range IPO At $11 To $13 Per Share; Valued At Over $600M" # rubocop:disable Metrics/LineLength
    expect(@entry["title"]).to eq title
  end

  it "should allow setting field values with hash syntax" do
    @entry["title"] = "Foobar"
    expect(@entry.title).to eq "Foobar"
  end
end
