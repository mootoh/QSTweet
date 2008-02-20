require 'osx/cocoa'
require 'open-uri'
require 'rubygems'
require 'json'

class TwitterPluginSource < OSX::QSObjectSource
  @friends = []

  def indexIsValidFromDate_forEntry(index, entry)
    true
  end

  def iconForEntry(dict)
    Shared.logger.info(dict.class.to_s)
    nil
  end

=begin
  - (NSString *)identifierForObject:(id <QSObject>)object{
        return nil;
    }
=end

  def name_pass
    screen_name.to_s + ':' + password
  end

  def objectsForEntry(entry)
    dict = OSX::NSUserDefaultsController.sharedUserDefaultsController.values;
    screen_name = dict.valueForKey("TwitterPreference.screenName")
    password    = dict.valueForKey("TwitterPreference.password")

    url = 'http://' + screen_name + ':' + password +
          '@twitter.com/statuses/friends/' + screen_name +
          '.json'
    Shared.logger.info(url)

    @friends = []
    objects = []
    begin
      @friends = JSON.parse(open(url).read)
      @friends.each do |j|
        obj = OSX::QSObject.objectWithName(j['name'])
        obj.setObject_forType('', 'TwitterPluginType')
        obj.setPrimaryType('TwitterPluginType')
        objects.push(obj)
      end
    end
    objects
  end

  # Object Handler Methods

  def setQuickIconForObject(object)
    # An icon that is either already in memory or easy to load
    if @friends
      her = @friends.find {|x| x['name'] == object.name.to_s}
      object.setIcon(OSX::NSImage.alloc.initWithContentsOfURL(OSX::NSURL.URLWithString(her['profile_image_url'])))
    end
  end

=begin
- (BOOL)loadIconForObject:(QSObject *)object{
        return NO;
    id data=[object objectForType:kTwitterPluginType];
        [object setIcon:nil];
    return YES;
}
*/
=end
end
