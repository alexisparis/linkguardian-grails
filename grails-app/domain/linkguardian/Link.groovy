package linkguardian

class Link {

  static constraints = {
    }

  static transients = [ "tags" ]

  static mapping = {
    fusionedTags index:true
    url index:true
    archived index:true
    creationDate index:true
  }

  String url
  String domain
  Note note = Note.Note_Null
  Date creationDate
  String fusionedTags
  Boolean archived = false
  String title
  String description

  List<String> tags
}
