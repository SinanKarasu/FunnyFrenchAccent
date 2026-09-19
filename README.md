# FunnyFrench – Playful Text Transformer

FunnyFrench turns *your own text* into a light-hearted, mock-French accent.
It runs entirely on-device as a native iPhone, iPad, and Mac app. No accounts,
no tracking.

## How it works
- Uses Apple’s Natural Language framework for sentence boundaries, lexical
  classes, lemmatization, and named-entity recognition
- Preserves the original punctuation, spacing, paragraphs, capitalization, and names
- Applies a small, readable set of pronunciation cues ("the" → "ze", "with" → "wiz")
- Sprinkles in expressions such as *mon ami*, *bien sûr*, *merci*, and *très*
- Occasionally uses French-shaped emphasis, pre-verb object pronouns, informal
  question order, and selected post-noun adjectives for comedic flavor
- Makes deterministic choices, so the same input produces the same joke

French normally uses subject–verb–object order, much like English. The phrasing
changes here imitate recognizable features such as “Moi, I think…”, intonation
questions, “I you love” object-pronoun order, and post-noun adjectives rather
than indiscriminately scrambling words.

## Privacy
- We do not collect, store, or transmit your text. Processing is local on your device.

## Testing

The transformation engine is also a small Swift package. Run its focused test
suite with `swift test` from the repository root.

## Content
- This app only transforms *user-provided* text. It does not target a protected class and offers no built-in content. It’s a playful filter comparable to a meme caption tool.

## Credits
Some transformation rules were inspired by Sean Patrick Payne’s *Fake French Accent Translator* (2014).

- Blog post: [https://www.payneful.co.uk/blogsplosion/2014/11/16/so-i-built-a-fake-french-accent-translator/](https://www.payneful.co.uk/blogsplosion/2014/11/16/so-i-built-a-fake-french-accent-translator/)
- GitHub repository: [https://github.com/SPPayne/fake_french_accent_translator](https://github.com/SPPayne/fake_french_accent_translator)
