import { CategoryMenu, Hero, Incentives, IntroducingSection, OurProcessSection, Newsletter, ProductsSection } from "@/components";

export default function Home() {
  return (
    <>
    <Hero 
      title="One Shop. Endless Possibilities."
      subtitle="Websites, templates, tools, and resources to help you grow."
      primaryCTA={{ text: "SHOP NOW", link: "#spots-grid" }}
      /* secondaryCTA={{ text: "Hire Me", link: "#services" }}*/
    />
    <OurProcessSection
      steps={[
        { title: "Smart Watches", description: "Hitech Innovations", image: "banner_minimalism3.jpg.webp", link: "/shop/watches" },
        { title: "Cool Shoes", description: "Bring fashion.", image: "banner_minimalism2.jpg", link: "/shop/shoes" },
        { title: "Electronics", description: "Sound Explosion.", image: "banner_minimalism1-1.jpg.webp", link: "/shop/electronics" }
      ]}
    />
    {/* 
    <IntroducingSection />
    <CategoryMenu />*/}
    <ProductsSection />
    </>
  );
}
