import { useState } from "react";

import { NFTCard } from "./components/nftCard";

import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'

const Home: NextPage = () => {

  const [wallet, setWalletAddress] = useState("");
  const [collection, setCollectionAddress] = useState("");
  const [fetchForCollection, setFetchForCollection] = useState(false);
  const [NFTs, setNFTs] = useState([])

  const fetchNFTs = async () => {
    let nfts; 
    console.log("fetching nfts");
    const api_key = "<REDACTED>"
    const baseURL = `https://eth-mainnet.alchemyapi.io/v2/${api_key}/getNFTs/`;
    var requestOptions = {
      method: 'GET'
    };

    if (!collection.length && !wallet) {
      return; 
    }
    
    if (!collection.length) {
    
      const fetchURL = `${baseURL}?owner=${wallet}`;

      const nftResponse = await fetch(fetchURL, requestOptions);
      nfts = await nftResponse.json();
    } else {
      console.log("fetching nfts for collection owned by address")
      const fetchURL = `${baseURL}?owner=${wallet}&contractAddresses%5B%5D=${collection}`;
      const nftResponse = await fetch(fetchURL, requestOptions);
      nfts = await nftResponse.json();
    }

    if (nfts) {
      console.log("nfts:", nfts)
      setNFTs(nfts.ownedNfts)
    }
  }

  const fetchNFTsForCollection = async () => {
    if (!collection.length) {
      return;
    }

    var requestOptions = {
      method: 'GET'
    };
    const api_key = "<REDACTED>"
    const baseURL = `https://eth-mainnet.alchemyapi.io/v2/${api_key}/getNFTsForCollection/`;
    const fetchURL = `${baseURL}?contractAddress=${collection}&withMetadata=${"true"}`;
    const nftResponse = await fetch(fetchURL, requestOptions);
    const nfts = await nftResponse.json();
    if (nfts) {
      console.log("NFTs in collection:", nfts)
      setNFTs(nfts.nfts)
    }
  }

  return (
    <div className="flex flex-col items-center justify-center py-8 gap-y-3">
      <div className="flex flex-col w-full justify-center items-center gap-y-2">
        <input 
          onChange={ (e) => setWalletAddress(e.target.value) } 
          disabled={fetchForCollection}
          value={wallet}
          type={"text"} 
          placeholder="Add your wallet address" />
        <input 
          onChange={ (e) => setCollectionAddress(e.target.value) } 
          value={collection}
          type={"text"} 
          placeholder="Add the collection address" />
        <label className="text-gray-600 ">
          <input 
            type={"checkbox"} 
            onChange={ (e)=> setFetchForCollection(e.target.checked) }
            className="mr-2" />
          Fetch for collection
        </label>
        <button className={"disabled:bg-slate-500 text-white bg-blue-400 px-4 py-2 mt-3 rounded-sm w-1/5"}
          onClick={
            () => {
              if (fetchForCollection) {
                fetchNFTsForCollection();
              } else {
                fetchNFTs();
              }
            }}
        >Let's go! </button>
      </div>
      <div className='flex flex-wrap gap-y-12 mt-4 w-5/6 gap-x-2 justify-center'>
        {
          NFTs.length && NFTs.map(nft => {
            return (
              <NFTCard nft={nft}></NFTCard>
            )
          })
        }
      </div>
    </div>
  )
}

export default Home
