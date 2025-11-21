import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Toaster } from "sonner";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

export const metadata: Metadata = {
  title: {
    default: "SCHNITTWERK by Vanessa Carosella | Ihr Salon in St. Gallen",
    template: "%s | SCHNITTWERK",
  },
  description:
    "Moderner Friseursalon in St. Gallen. Professionelle Haarschnitte, Färbungen und Styling. Jetzt online Termin buchen.",
  keywords: [
    "Friseur St. Gallen",
    "Haarschnitt",
    "Färbung",
    "Styling",
    "Salon",
    "Coiffeur",
  ],
  authors: [{ name: "SCHNITTWERK by Vanessa Carosella" }],
  creator: "SCHNITTWERK",
  metadataBase: new URL(
    process.env.NEXT_PUBLIC_APP_URL || "http://localhost:3000"
  ),
  openGraph: {
    type: "website",
    locale: "de_CH",
    url: "/",
    title: "SCHNITTWERK by Vanessa Carosella",
    description: "Moderner Friseursalon in St. Gallen",
    siteName: "SCHNITTWERK",
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-video-preview": -1,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="de" suppressHydrationWarning>
      <body className={`${inter.variable} font-sans antialiased`}>
        {children}
        <Toaster position="top-right" richColors closeButton />
      </body>
    </html>
  );
}
