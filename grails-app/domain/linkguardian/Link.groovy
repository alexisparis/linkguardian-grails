package linkguardian

class Link {

  static constraints = {
    }

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
