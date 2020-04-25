class CategoryGoodsListModelEntity {
	String code;
	List<CategoryGoodsListModelData> data;
	String message;

	CategoryGoodsListModelEntity({this.code, this.data, this.message});

	CategoryGoodsListModelEntity.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		if (json['data'] != null) {
			data = new List<CategoryGoodsListModelData>();(json['data'] as List).forEach((v) { data.add(new CategoryGoodsListModelData.fromJson(v)); });
		}
		message = json['message'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['code'] = this.code;
		if (this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
		data['message'] = this.message;
		return data;
	}
}

class CategoryGoodsListModelData {
	String image;
	double oriPrice;
	double presentPrice;
	String goodsId;
	String goodsName;

	CategoryGoodsListModelData({this.image, this.oriPrice, this.presentPrice, this.goodsId, this.goodsName});

	CategoryGoodsListModelData.fromJson(Map<String, dynamic> json) {
		image = json['image'];
		oriPrice = json['oriPrice'];
		presentPrice = json['presentPrice'];
		goodsId = json['goodsId'];
		goodsName = json['goodsName'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['image'] = this.image;
		data['oriPrice'] = this.oriPrice;
		data['presentPrice'] = this.presentPrice;
		data['goodsId'] = this.goodsId;
		data['goodsName'] = this.goodsName;
		return data;
	}
}
