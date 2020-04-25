class CategoryModelEntity {
	String code;
	List<CategoryModelData> data;
	String message;

	CategoryModelEntity({this.code, this.data, this.message});

	CategoryModelEntity.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		if (json['data'] != null) {
			data = new List<CategoryModelData>();(json['data'] as List).forEach((v) { data.add(new CategoryModelData.fromJson(v)); });
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

class CategoryModelData {
	String image;
	List<CategoryModelDataBxmallsubdto> bxMallSubDto;
	dynamic comments;
	String mallCategoryId;
	String mallCategoryName;

	CategoryModelData({this.image, this.bxMallSubDto, this.comments, this.mallCategoryId, this.mallCategoryName});

	CategoryModelData.fromJson(Map<String, dynamic> json) {
		image = json['image'];
		if (json['bxMallSubDto'] != null) {
			bxMallSubDto = new List<CategoryModelDataBxmallsubdto>();(json['bxMallSubDto'] as List).forEach((v) { bxMallSubDto.add(new CategoryModelDataBxmallsubdto.fromJson(v)); });
		}
		comments = json['comments'];
		mallCategoryId = json['mallCategoryId'];
		mallCategoryName = json['mallCategoryName'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['image'] = this.image;
		if (this.bxMallSubDto != null) {
      data['bxMallSubDto'] =  this.bxMallSubDto.map((v) => v.toJson()).toList();
    }
		data['comments'] = this.comments;
		data['mallCategoryId'] = this.mallCategoryId;
		data['mallCategoryName'] = this.mallCategoryName;
		return data;
	}
}

class CategoryModelDataBxmallsubdto {
	String mallSubName;
	String comments;
	String mallCategoryId;
	String mallSubId;

	CategoryModelDataBxmallsubdto({this.mallSubName, this.comments, this.mallCategoryId, this.mallSubId});

	CategoryModelDataBxmallsubdto.fromJson(Map<String, dynamic> json) {
		mallSubName = json['mallSubName'];
		comments = json['comments'];
		mallCategoryId = json['mallCategoryId'];
		mallSubId = json['mallSubId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['mallSubName'] = this.mallSubName;
		data['comments'] = this.comments;
		data['mallCategoryId'] = this.mallCategoryId;
		data['mallSubId'] = this.mallSubId;
		return data;
	}
}
