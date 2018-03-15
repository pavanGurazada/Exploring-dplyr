#define ARMA_64BIT_WORD
#include <RcppArmadillo.h>

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::plugins(cpp11)]]
using namespace Rcpp;

using arma::sp_mat;

// [[Rcpp::export]]
sp_mat adj_mat(int n, double p) {
  
  Environment igraph("package:igraph");
  Function game_er = igraph["erdos.renyi.game"];
  Function get_adjacency = igraph["get.adjacency"];
  
  SEXP g = game_er(Named("n", n), Named("p", p));
  
  S4 A_m = get_adjacency(Named("g", g));
  
  sp_mat A = as<sp_mat>(A_m);
  
  return A;
}


/*** R
set.seed(20130810)
library(igraph)

adj_mat(100, 0.5)
*/
