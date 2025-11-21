import { Scissors, Heart, Award, Users } from "lucide-react";

export default function AboutPage() {
  return (
    <div className="flex flex-col">
      {/* Hero Section */}
      <section className="relative flex min-h-[60vh] items-center justify-center overflow-hidden bg-gradient-to-br from-schnittwerk-50 via-white to-gold-50">
        <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-5" />

        <div className="container-custom relative z-10 text-center">
          <h1 className="mb-6 text-4xl font-bold tracking-tight sm:text-5xl lg:text-6xl">
            Über uns
          </h1>
          <p className="mx-auto max-w-2xl text-lg text-schnittwerk-600 sm:text-xl">
            Die Geschichte von SCHNITTWERK und unsere Leidenschaft für
            perfektes Handwerk
          </p>
        </div>
      </section>

      {/* Story Section */}
      <section className="container-custom py-20">
        <div className="mx-auto max-w-3xl">
          <h2 className="mb-6 text-3xl font-bold">Unsere Geschichte</h2>
          <div className="space-y-4 text-lg text-schnittwerk-600">
            <p>
              SCHNITTWERK wurde von Vanessa Carosella mit einer klaren Vision
              gegründet: einen modernen Salon zu schaffen, der traditionelles
              Handwerk mit zeitgemäßem Design und erstklassigem Service
              verbindet.
            </p>
            <p>
              Im Herzen von St. Gallen gelegen, an der Rorschacherstrasse 152,
              ist SCHNITTWERK mehr als nur ein Friseursalon – es ist ein Ort,
              an dem sich Menschen wohlfühlen, wo Professionalität auf
              Herzlichkeit trifft und wo jeder Besuch zu einem besonderen
              Erlebnis wird.
            </p>
            <p>
              Mit jahrelanger Erfahrung und kontinuierlicher Weiterbildung in
              den neuesten Techniken und Trends, bieten wir unseren Kunden
              nicht nur einen Haarschnitt, sondern eine umfassende
              Beratung und ein individuelles Styling-Erlebnis.
            </p>
          </div>
        </div>
      </section>

      {/* Values Section */}
      <section className="bg-schnittwerk-50 py-20">
        <div className="container-custom">
          <div className="mb-12 text-center">
            <h2 className="mb-4 text-3xl font-bold">Unsere Werte</h2>
            <p className="mx-auto max-w-2xl text-lg text-schnittwerk-600">
              Was SCHNITTWERK besonders macht
            </p>
          </div>

          <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-4">
            {/* Handwerk */}
            <div className="glass rounded-2xl p-8 text-center">
              <div className="mb-4 inline-flex rounded-full bg-gold-100 p-4">
                <Scissors className="h-8 w-8 text-gold-600" />
              </div>
              <h3 className="mb-3 text-xl font-semibold">Handwerk</h3>
              <p className="text-schnittwerk-600">
                Meisterliches Können und präzise Technik in jedem Schnitt
              </p>
            </div>

            {/* Leidenschaft */}
            <div className="glass rounded-2xl p-8 text-center">
              <div className="mb-4 inline-flex rounded-full bg-gold-100 p-4">
                <Heart className="h-8 w-8 text-gold-600" />
              </div>
              <h3 className="mb-3 text-xl font-semibold">Leidenschaft</h3>
              <p className="text-schnittwerk-600">
                Liebe zum Detail und Begeisterung für unser Handwerk
              </p>
            </div>

            {/* Qualität */}
            <div className="glass rounded-2xl p-8 text-center">
              <div className="mb-4 inline-flex rounded-full bg-gold-100 p-4">
                <Award className="h-8 w-8 text-gold-600" />
              </div>
              <h3 className="mb-3 text-xl font-semibold">Qualität</h3>
              <p className="text-schnittwerk-600">
                Höchste Standards bei Produkten, Service und Ergebnis
              </p>
            </div>

            {/* Persönlichkeit */}
            <div className="glass rounded-2xl p-8 text-center">
              <div className="mb-4 inline-flex rounded-full bg-gold-100 p-4">
                <Users className="h-8 w-8 text-gold-600" />
              </div>
              <h3 className="mb-3 text-xl font-semibold">Persönlichkeit</h3>
              <p className="text-schnittwerk-600">
                Individuelle Beratung und auf Sie zugeschnittener Service
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Philosophy Section */}
      <section className="container-custom py-20">
        <div className="mx-auto max-w-3xl">
          <h2 className="mb-6 text-3xl font-bold">Unsere Philosophie</h2>
          <div className="space-y-4 text-lg text-schnittwerk-600">
            <p>
              Bei SCHNITTWERK glauben wir, dass jeder Mensch einzigartig ist –
              und genau so sollte auch sein Haarschnitt sein. Wir nehmen uns
              Zeit für eine ausführliche Beratung, um Ihre Wünsche,
              Ihren Stil und Ihre Persönlichkeit zu verstehen.
            </p>
            <p>
              Wir arbeiten ausschließlich mit hochwertigen Produkten, die Ihr
              Haar pflegen und schützen. Nachhaltigkeit und Umweltbewusstsein
              sind uns wichtig – deshalb setzen wir auf Produkte und Verfahren,
              die Mensch und Natur respektieren.
            </p>
            <p>
              Unser Team bildet sich kontinuierlich weiter, um Ihnen stets die
              neuesten Techniken, Trends und Behandlungsmethoden anbieten zu
              können. Ihr Wohlbefinden und Ihre Zufriedenheit stehen bei uns an
              erster Stelle.
            </p>
          </div>
        </div>
      </section>

      {/* Location Section */}
      <section className="bg-schnittwerk-900 py-20 text-white">
        <div className="container-custom text-center">
          <h2 className="mb-4 text-3xl font-bold">Besuchen Sie uns</h2>
          <p className="mb-6 text-xl text-schnittwerk-200">
            Rorschacherstrasse 152<br />
            9000 St. Gallen
          </p>
          <p className="mb-8 text-schnittwerk-300">
            Wir freuen uns auf Ihren Besuch und darauf, Sie mit unserem Service
            zu begeistern.
          </p>
        </div>
      </section>
    </div>
  );
}
