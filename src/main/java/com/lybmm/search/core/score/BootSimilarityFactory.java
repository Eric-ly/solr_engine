package com.lybmm.search.core.score;

import org.apache.lucene.search.similarities.Similarity;
import org.apache.solr.schema.SimilarityFactory;

public class BootSimilarityFactory extends SimilarityFactory {
    @Override
    public Similarity getSimilarity(){
        return new  BootSimilarity();
    }
}
