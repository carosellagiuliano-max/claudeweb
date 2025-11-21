"use client";

import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Calendar, Menu, ShoppingBag, X } from "lucide-react";
import { useState } from "react";

const navigation = [
  { name: "Home", href: "/" },
  { name: "Leistungen", href: "/leistungen" },
  { name: "Team", href: "/team" },
  { name: "Über uns", href: "/ueber-uns" },
  { name: "Kontakt", href: "/kontakt" },
  { name: "Shop", href: "/shop" },
];

export function PublicHeader() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  return (
    <header className="sticky top-0 z-50 w-full border-b border-schnittwerk-200/50 glass">
      <nav className="container-custom flex h-16 items-center justify-between">
        {/* Logo */}
        <Link href="/" className="text-2xl font-bold tracking-tight">
          SCHNITTWERK
        </Link>

        {/* Desktop Navigation */}
        <div className="hidden items-center gap-6 md:flex">
          {navigation.map((item) => (
            <Link
              key={item.name}
              href={item.href}
              className="text-sm font-medium text-schnittwerk-700 transition-colors hover:text-schnittwerk-900"
            >
              {item.name}
            </Link>
          ))}
        </div>

        {/* Desktop CTA */}
        <div className="hidden items-center gap-3 md:flex">
          <Button variant="ghost" size="icon" asChild>
            <Link href="/warenkorb">
              <ShoppingBag className="h-5 w-5" />
              <span className="sr-only">Warenkorb</span>
            </Link>
          </Button>
          <Button size="sm" asChild>
            <Link href="/termin-buchen">
              <Calendar className="mr-2 h-4 w-4" />
              Termin buchen
            </Link>
          </Button>
        </div>

        {/* Mobile Menu Button */}
        <button
          type="button"
          className="md:hidden"
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
        >
          {mobileMenuOpen ? (
            <X className="h-6 w-6" />
          ) : (
            <Menu className="h-6 w-6" />
          )}
        </button>
      </nav>

      {/* Mobile Menu */}
      {mobileMenuOpen && (
        <div className="border-t border-schnittwerk-200/50 bg-white p-4 md:hidden">
          <div className="flex flex-col gap-4">
            {navigation.map((item) => (
              <Link
                key={item.name}
                href={item.href}
                className="text-base font-medium text-schnittwerk-700 transition-colors hover:text-schnittwerk-900"
                onClick={() => setMobileMenuOpen(false)}
              >
                {item.name}
              </Link>
            ))}
            <div className="flex flex-col gap-2 pt-4">
              <Button asChild>
                <Link href="/termin-buchen">
                  <Calendar className="mr-2 h-4 w-4" />
                  Termin buchen
                </Link>
              </Button>
              <Button variant="outline" asChild>
                <Link href="/warenkorb">
                  <ShoppingBag className="mr-2 h-4 w-4" />
                  Warenkorb
                </Link>
              </Button>
            </div>
          </div>
        </div>
      )}
    </header>
  );
}
