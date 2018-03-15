#define ARMA_64BIT_WORD
#include <RcppArmadillo.h>

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::plugins(cpp11)]]
using namespace Rcpp;

using arma::sp_mat;

// [[Rcpp::export]]
sp_mat call_functions(int n, double p) {
  
  Environment graph("package: igraph");
  Function game_er = graph["erdos.renyi.game"];
  Function get_adjacency = graph["get.adjacency"];
  
  List g = graph(Named("n", n), Named("p", p));
  
  sp_mat A = 
  
}


/*** R
set.seed(20130810)
library(igraph)

call_functions(100, 0.5, igraph::erdos.renyi.game, igraph::get.adjacency)
*/
