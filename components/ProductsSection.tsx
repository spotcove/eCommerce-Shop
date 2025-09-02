"use client";

import React, { useEffect, useState } from "react";
import ProductItem from "./ProductItem";
import Heading from "./Heading";

const ProductsSection = () => {
  const [products, setProducts] = useState<Product[]>([]);

  useEffect(() => {
    const fetchProducts = async () => {
      const res = await fetch("http://localhost:3001/api/products");
      const data = await res.json();
      setProducts(data);
    };
    fetchProducts();
  }, []);

  return (
    <div className="bg-primary border-t-4 border-white justify-center">
      <div className="max-w-screen-2xl mx-auto pt-5">
        <Heading title="Featured Products" />
        <div className="grid items-center justify-items-center  grid-cols-4 justify-items-center max-w-screen-2xl mx-auto py-10 gap-x-2 px-10 gap-y-8 max-xl:grid-cols-3 max-md:grid-cols-2 max-sm:grid-cols-1">
          {products.map((product: Product) => (
            <ProductItem key={product.id} product={product} color="black" />
          ))}
        </div>
      </div>
    </div>
  );
};

export default ProductsSection;
