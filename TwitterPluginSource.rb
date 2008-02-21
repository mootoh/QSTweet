require 'osx/cocoa'
require 'open-uri'
require 'rubygems'
require 'json'

class TwitterPluginSource < OSX::QSObjectSource
  @@count = 0
  FRIENDS = File.dirname(__FILE__) + '/friends.dat'

  def initialize
    super
    @friends = File.exist?(FRIENDS) ? Marshal.load(open(FRIENDS)) : []
  end

  def indexIsValidFromDate_forEntry(index, entry)
    true
  end

  def iconForEntry(dict) # dict.keys => name, source, ID, bundle
    OSX::QSResourceManager.imageNamed('girl_square')
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

    @friends = []
    objects = []
    count = 1

    while true
      url = 'http://' + screen_name + ':' + password +
            '@twitter.com/statuses/friends/' + screen_name + '.json'

      if count > 1
        url += '?page=' + count.to_s
      end
      count += 1

      friends = JSON.parse(open(url).read)
      friends.each do |friend|
        Shared.logger.info(friend['screen_name'])
        obj = OSX::QSObject.objectWithName(friend['screen_name'])
        obj.setObject_forType('', 'TwitterPluginType')
        obj.setPrimaryType('TwitterPluginType')
        objects.push(obj)
      end

      @friends += friends

      break if (friends.size < 100)
    end
    @friends.uniq!
    Marshal.dump(@friends, open(FRIENDS, 'w'))
    objects
  end

  # Object Handler Methods

  def setQuickIconForObject(object)
    object.setIcon(nil) 
  end

  def loadIconForObject(object)
    return false unless @friends
    return false if @friends.empty?

    Shared.logger.info('1')

    her = @friends.find {|x| x['screen_name'] == object.name.to_s}
    img = OSX::NSImage.alloc.initWithContentsOfURL(OSX::NSURL.URLWithString(her['profile_image_url']))
    return false unless img

    object.setIcon(img)
    true
  end
end
