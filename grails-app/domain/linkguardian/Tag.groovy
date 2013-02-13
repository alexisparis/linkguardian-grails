package linkguardian

class Tag
{
    static final LABEL_MAX_LENGTH = 100

    static constraints = {}

    static hasMany = [links:Link]

    static belongsTo = Link

    static mapping = {
        label index:true, length: LABEL_MAX_LENGTH, unique: true
    }

    String label
}
