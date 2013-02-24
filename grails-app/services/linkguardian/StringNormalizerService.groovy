package linkguardian

import java.text.Normalizer

class StringNormalizerService
{
    def pattern = java.util.regex.Pattern.compile("\\W")

    def normalize(String input)
    {
        def result = new ArrayList<String>()

        if ( input != null )
        {
            input.tokenize(" ").each {
                def token = it
                if ( token != null )
                {
                    token = token.trim()

                    token = Normalizer.normalize(token.trim(), Normalizer.Form.NFD)
                                      .replaceAll("\\p{InCombiningDiacriticalMarks}+", "")
                                      .replaceAll("_", "")

                    if ( token != null )
                    {
                        token = token.trim()
                        if ( ! token.isEmpty() )
                        {
                            def matcher = pattern.matcher(token)
                            token = matcher.replaceAll("")

                            result.add(token)
                        }
                    }

                }
            }
        }

        return result
    }
}
