import Testing
@testable import FunnyFrenchCore

@Suite("Funny French processor")
struct FunnyFrenchProcessorTests {
    private let processor = FunnyFrenchProcessor(addFlourishes: false)

    @Test("uses selective pronunciation instead of corrupting every vowel")
    func selectiveAccent() {
        #expect(processor.transform(text: "This is the weather.") == "Zis eez ze veazer.")
    }

    @Test("sprinkles French vocabulary")
    func vocabulary() {
        let result = processor.transform(
            text: "Hello, my dear friend! Thank you very much."
        )
        #expect(result == "Allô, mon cher ami! Merci très much.")
    }

    @Test("uses French-shaped emphasis and selected post-noun adjectives")
    func phrasing() {
        let result = processor.transform(
            text: "I think this is a beautiful idea."
        )
        #expect(result == "Moi, I zink zis eez an idea beautiful.")
    }

    @Test("can move a simple object into topic position")
    func objectTopic() {
        #expect(processor.transform(text: "I like this plan.") == "Zis plan, I like.")
    }

    @Test("moves object pronouns before the verb like French clitics")
    func objectPronounOrder() {
        #expect(processor.transform(text: "I love you.") == "I you love.")
        #expect(processor.transform(text: "I loved you.") == "I you loved.")
        #expect(processor.transform(text: "We understand them well.") == "Ve zem understand vell.")
        #expect(processor.transform(text: "She sees him clearly.") == "She 'im sees clearly.")
    }

    @Test("uses named entities to leave names alone")
    func preservesNames() {
        let result = processor.transform(text: "William thinks with Wendy.")
        #expect(result.contains("William"))
        #expect(result.contains("Wendy"))
        #expect(result.contains("zinks wiz"))
    }

    @Test("uses informal question order")
    func questionOrder() {
        #expect(processor.transform(text: "Do you like this?") == "You like zis?")
    }

    @Test("preserves paragraphs and is deterministic")
    func stableFormatting() {
        let decorated = FunnyFrenchProcessor()
        let input = "This is a fairly long first sentence.\n\nThis is another fairly long sentence."
        let first = decorated.transform(text: input)
        let second = decorated.transform(text: input)

        #expect(first == second)
        #expect(first.contains("\n\n"))
    }
}
