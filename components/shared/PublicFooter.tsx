import Link from "next/link";
import { Instagram, Facebook, Phone, Mail, MapPin } from "lucide-react";

export function PublicFooter() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="border-t border-schnittwerk-200 bg-schnittwerk-50">
      <div className="container-custom py-12">
        <div className="grid gap-8 md:grid-cols-4">
          {/* Brand */}
          <div className="space-y-4">
            <h3 className="text-2xl font-bold">SCHNITTWERK</h3>
            <p className="text-sm text-schnittwerk-600">
              Ihr moderner Friseursalon im Herzen von St. Gallen.
            </p>
            <div className="flex gap-4">
              <a
                href="https://instagram.com"
                target="_blank"
                rel="noopener noreferrer"
                className="text-schnittwerk-600 hover:text-schnittwerk-900"
              >
                <Instagram className="h-5 w-5" />
                <span className="sr-only">Instagram</span>
              </a>
              <a
                href="https://facebook.com"
                target="_blank"
                rel="noopener noreferrer"
                className="text-schnittwerk-600 hover:text-schnittwerk-900"
              >
                <Facebook className="h-5 w-5" />
                <span className="sr-only">Facebook</span>
              </a>
            </div>
          </div>

          {/* Navigation */}
          <div>
            <h4 className="mb-4 font-semibold">Navigation</h4>
            <ul className="space-y-2 text-sm">
              <li>
                <Link
                  href="/leistungen"
                  className="text-schnittwerk-600 hover:text-schnittwerk-900"
                >
                  Leistungen
                </Link>
              </li>
              <li>
                <Link
                  href="/team"
                  className="text-schnittwerk-600 hover:text-schnittwerk-900"
                >
                  Team
                </Link>
              </li>
              <li>
                <Link
                  href="/ueber-uns"
                  className="text-schnittwerk-600 hover:text-schnittwerk-900"
                >
                  Über uns
                </Link>
              </li>
              <li>
                <Link
                  href="/shop"
                  className="text-schnittwerk-600 hover:text-schnittwerk-900"
                >
                  Shop
                </Link>
              </li>
            </ul>
          </div>

          {/* Legal */}
          <div>
            <h4 className="mb-4 font-semibold">Rechtliches</h4>
            <ul className="space-y-2 text-sm">
              <li>
                <Link
                  href="/impressum"
                  className="text-schnittwerk-600 hover:text-schnittwerk-900"
                >
                  Impressum
                </Link>
              </li>
              <li>
                <Link
                  href="/datenschutz"
                  className="text-schnittwerk-600 hover:text-schnittwerk-900"
                >
                  Datenschutz
                </Link>
              </li>
              <li>
                <Link
                  href="/agb"
                  className="text-schnittwerk-600 hover:text-schnittwerk-900"
                >
                  AGB
                </Link>
              </li>
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h4 className="mb-4 font-semibold">Kontakt</h4>
            <ul className="space-y-3 text-sm text-schnittwerk-600">
              <li className="flex items-start gap-2">
                <MapPin className="mt-0.5 h-4 w-4 shrink-0" />
                <span>
                  Rorschacherstrasse 152
                  <br />
                  9000 St. Gallen
                </span>
              </li>
              <li className="flex items-center gap-2">
                <Phone className="h-4 w-4 shrink-0" />
                <a href="tel:+41712345678" className="hover:text-schnittwerk-900">
                  +41 71 234 56 78
                </a>
              </li>
              <li className="flex items-center gap-2">
                <Mail className="h-4 w-4 shrink-0" />
                <a
                  href="mailto:info@schnittwerk.ch"
                  className="hover:text-schnittwerk-900"
                >
                  info@schnittwerk.ch
                </a>
              </li>
            </ul>
          </div>
        </div>

        <div className="mt-8 border-t border-schnittwerk-200 pt-8 text-center text-sm text-schnittwerk-600">
          <p>
            © {currentYear} SCHNITTWERK by Vanessa Carosella. Alle Rechte
            vorbehalten.
          </p>
        </div>
      </div>
    </footer>
  );
}
