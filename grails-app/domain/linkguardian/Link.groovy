package linkguardian

class Link {

  // adapt values
  static URL_MAX_LENGTH = 100
  static TAGS_MAX_LENGTH = 400
  static TITLE_MAX_LENGTH = 200
  static DESCRIPTION_MAX_LENGTH = 2000

  // do not change
  static DOMAIN_MAX_LENGTH = URL_MAX_LENGTH

  static constraints = {
      url size: 1..URL_MAX_LENGTH, blank: false
      domain size: 1..DOMAIN_MAX_LENGTH, blank: false
      fusionedTags size: 0..TAGS_MAX_LENGTH
      title size: 0..TITLE_MAX_LENGTH
      description size: 0..DESCRIPTION_MAX_LENGTH
  }

  static belongsTo = [person: Person]

  static mapping = {
    fusionedTags index:true
    url index:true
    read index:true
    creationDate index:true
  }

  String url
  String domain
  Note note = Note.Note_0
  Date creationDate
  String fusionedTags
  Boolean read = false
  String title
  String description
}
