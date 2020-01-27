obs = obslua
bit = require("bit")

source_def = {}
source_def.id = "obs_ms"
source_def.output_flags = bit.bor(obs.OBS_SOURCE_VIDEO, obs.OBS_SOURCE_CUSTOM_DRAW)

function image_source_load(image, file)
	obs.obs_enter_graphics();
	obs.gs_image_file_free(image);
	obs.obs_leave_graphics();

	obs.gs_image_file_init(image, file);

	obs.obs_enter_graphics();
	obs.gs_image_file_init_texture(image);
	obs.obs_leave_graphics();

	if not image.loaded then
		print("请确保图片存在: " .. file);
	end
end

source_def.get_name = function()
	return "毫秒级时钟"
end

source_def.create = function(source, settings)
	local data = {}

	data.n0 = obs.gs_image_file()
	data.n1 = obs.gs_image_file()
	data.n2 = obs.gs_image_file()
	data.n3 = obs.gs_image_file()
	data.n4 = obs.gs_image_file()
	data.n5 = obs.gs_image_file()
	data.n6 = obs.gs_image_file()
	data.n7 = obs.gs_image_file()
	data.n8 = obs.gs_image_file()
	data.n9 = obs.gs_image_file()
	data.n = obs.gs_image_file()


	image_source_load(data.n0, script_path() .. "obs_ms/0.png")
	image_source_load(data.n1, script_path() .. "obs_ms/1.png")
	image_source_load(data.n2, script_path() .. "obs_ms/2.png")
	image_source_load(data.n3, script_path() .. "obs_ms/3.png")
	image_source_load(data.n4, script_path() .. "obs_ms/4.png")
	image_source_load(data.n5, script_path() .. "obs_ms/5.png")
	image_source_load(data.n6, script_path() .. "obs_ms/6.png")
	image_source_load(data.n7, script_path() .. "obs_ms/7.png")
	image_source_load(data.n8, script_path() .. "obs_ms/8.png")
	image_source_load(data.n9, script_path() .. "obs_ms/9.png")
	image_source_load(data.n, script_path() .. "obs_ms/and.png")

	return data
end

source_def.destroy = function(data)
	obs.obs_enter_graphics();
	obs.gs_image_file_free(data.n0);
	obs.gs_image_file_free(data.n1);
	obs.gs_image_file_free(data.n2);
	obs.gs_image_file_free(data.n3);
	obs.gs_image_file_free(data.n4);
	obs.gs_image_file_free(data.n5);
	obs.gs_image_file_free(data.n6);
	obs.gs_image_file_free(data.n7);
	obs.gs_image_file_free(data.n8);
	obs.gs_image_file_free(data.n9);
	obs.gs_image_file_free(data.n);

	obs.obs_leave_graphics();
end

source_def.video_render = function(data, effect)
	if not data.n.texture then
		return;
	end
	local time = os.date("*t")
	local ms = string.match(tostring(os.clock()), "%d%.(%d+)")
	local hours, mins, seconds = AddZeroFrontNum(2,time.hour), AddZeroFrontNum(2,time.min), AddZeroFrontNum(2,time.sec)

	effect = obs.obs_get_base_effect(obs.OBS_EFFECT_DEFAULT)

	obs.gs_blend_state_push()
	obs.gs_reset_blend_state()

	while obs.gs_effect_loop(effect, "Draw") do
		
		local number=tostring(hours)
		local k=string.len(number)
		local list1={}
			for i=1,k do
				list1[i]=string.sub(number,i,i)
			end
			obs.obs_source_draw(get_number(data,list1[1]),0, 0, 0, 0, false);
			obs.obs_source_draw(get_number(data,list1[2]),22, 0, 0, 0, false);
		obs.obs_source_draw(data.n.texture, 44, 0, 0, 0, false);

		local number=tostring(mins)
		local k=string.len(number)
		local list1={}
			for i=1,k do
				list1[i]=string.sub(number,i,i)
			end
			obs.obs_source_draw(get_number(data,list1[1]),66, 0, 0, 0, false);
			obs.obs_source_draw(get_number(data,list1[2]),88, 0, 0, 0, false);
		obs.obs_source_draw(data.n.texture, 110, 0, 0, 0, false);

		local number=tostring(seconds)
		local k=string.len(number)
		local list1={}
			for i=1,k do
				list1[i]=string.sub(number,i,i)
			end
			obs.obs_source_draw(get_number(data,list1[1]),132, 0, 0, 0, false);
			obs.obs_source_draw(get_number(data,list1[2]),154, 0, 0, 0, false);
		obs.obs_source_draw(data.n.texture, 176, 0, 0, 0, false);

		local number=tostring(ms)
		local k=string.len(number)
		local list1={}
			for i=1,k do
				list1[i]=string.sub(number,i,i)
			end
			obs.obs_source_draw(get_number(data,list1[1]),198, 0, 0, 0, false);
			obs.obs_source_draw(get_number(data,list1[2]),220, 0, 0, 0, false);
			obs.obs_source_draw(get_number(data,list1[3]),242, 0, 0, 0, false);

	end

	obs.gs_blend_state_pop()
end

function DightNum(num)
    if math.floor(num) ~= num or num < 0 then
        return -1
    elseif 0 == num then
        return 1
    else
        local tmp_dight = 0
        while num > 0 do
            num = math.floor(num/10)
            tmp_dight = tmp_dight + 1
        end
        return tmp_dight 
    end
end

function AddZeroFrontNum(dest_dight, num)
    local num_dight = DightNum(num)
    if -1 == num_dight then 
        return -1 
    elseif num_dight >= dest_dight then
        return tostring(num)
    else
        local str_e = ""
        for var =1, dest_dight - num_dight do
            str_e = str_e .. "0"
        end
        return str_e .. tostring(num)
    end
end


function get_number(data,n)
	local t=data.n0.texture
	if n=='0' then
		t=data.n0.texture
	elseif  n=='1' then
		t=data.n1.texture
	elseif  n=='2' then
		t=data.n2.texture
	elseif  n=='3' then
		t=data.n3.texture
	elseif  n=='4' then
		t=data.n4.texture
	elseif  n=='5' then
		t=data.n5.texture
	elseif  n=='6' then
		t=data.n6.texture
	elseif  n=='7' then
		t=data.n7.texture
	elseif  n=='8' then
		t=data.n8.texture
	elseif  n=='9' then
		t=data.n9.texture
	end
	return t
end

source_def.get_width = function(data)
	return 264
end

source_def.get_height = function(data)
	return 30
end

function script_description()
	return "obs毫秒级时钟"
end

obs.obs_register_source(source_def)
