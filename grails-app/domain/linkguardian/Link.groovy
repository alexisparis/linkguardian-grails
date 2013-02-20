package linkguardian

class Link {

  // adapt values
  static final URL_MAX_LENGTH = 100
  //static final TAGS_MAX_LENGTH = 100
  static final TITLE_MAX_LENGTH = 100
  static final DESCRIPTION_MAX_LENGTH = 200

  // do not change
  static final DOMAIN_MAX_LENGTH = URL_MAX_LENGTH

  static constraints = {
  }

  static belongsTo = [person: Person]

  static mapping = {
  //  fusionedTags index:true, length: TAGS_MAX_LENGTH
    url index:true, length: URL_MAX_LENGTH
    read index:true
    creationDate index:true
    domain length: DOMAIN_MAX_LENGTH
    title length:  TITLE_MAX_LENGTH
    description length:  DESCRIPTION_MAX_LENGTH
    tags fetch: 'join', lazy: false
    note enumType: Note
    person index: true
  }

  //  static belongsTo = Author
  static hasMany = [tags:Tag]

  String url
  String domain
  Note note = Note.Note_0
  Date creationDate
  //String fusionedTags
  Boolean read = false
  String title
  String description
}
