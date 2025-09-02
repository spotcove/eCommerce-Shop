// *********************
// Role of the component: IntroducingSection with the text "Introducing Singitronic"
// Name of the component: IntroducingSection.tsx
// Developer: Aleksandar Kuzmanovic
// Version: 1.0
// Component call: <IntroducingSection />
// Input parameters: no input parameters
// Output: Section with the text "Introducing Singitronic" and button
// *********************

import Link from "next/link";
import React from "react";

export default function OurProcessSection({ steps }) {
  return (
    <section className="bg-primary py-5">
      <div className="max-w-8xl mx-auto px-4">
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {steps.map((step, index) => (
            <a
              key={index}
              href={step.link}
              className="relative group flex items-center rounded-2xl overflow-hidden bg-secondary shadow-sm h-56"
            >
              {/* Text wrapper - vertically centered always */}
              <div className="flex flex-col items-start justify-center w-1/2 px-6 text-left z-10 transition-all duration-300">
                <p className="text-secondary text-lg">{step.description}</p>
                <h5 className="text-primary text-3xl">{step.title}</h5>

                {/* More text (takes up space, but hidden until hover) */}
                <span className="text-primary text-sm max-h-0 overflow-hidden opacity-0 transition-all duration-300 group-hover:max-h-10 group-hover:opacity-100">
                  More →
                </span>
              </div>

              {/* Background image on right */}
              <div
                className="absolute right-0 top-0 bottom-0 w-1/2 bg-no-repeat bg-cover bg-right transition-transform duration-500 group-hover:scale-110"
                style={{ backgroundImage: `url(${step.image})` }}
              ></div>
            </a>
          ))}
        </div>
      </div>
    </section>


  );
}

/*
const OurProcessSection = () => {
  return (
    <div className="py-20 pt-24 bg-gradient-to-l from-white to-blue-600">
      <div className="text-center flex flex-col gap-y-5 items-center">
        <h2 className="text-white text-8xl font-extrabold text-center mb-2 max-md:text-6xl max-[480px]:text-4xl">
          INTRODUCING <span className="text-black">SINGI</span><span className="text-blue-600">TRONIC</span>
        </h2>
        <div>
          <p className="text-white text-center text-2xl font-semibold max-md:text-xl max-[480px]:text-base">
            Buy the latest electronics.
          </p>
          <p className="text-white text-center text-2xl font-semibold max-md:text-xl max-[480px]:text-base">
            The best electronics for tech lovers.
          </p>
          <Link href="/shop" className="block text-blue-600 bg-white font-bold px-12 py-3 text-xl hover:bg-gray-100 w-96 mt-2  max-md:text-lg max-md:w-72 max-[480px]:w-60 mx-auto">
            SHOP NOW
          </Link>
        </div>
      </div>
    </div>
  );
};

export default OurProcessSection;
*/
